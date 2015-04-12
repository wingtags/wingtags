#module PageScopeMethods
  # Specify the <tt>per_page</tt> value for the preceding <tt>page</tt> scope
  #   Model.page(3).per(10)
#  def per(num)
#    if (n = num.to_i) < 0 || !(/^\d/ =~ num.to_s)
#      self
#    elsif n.zero?
#      limit(n)
#    elsif max_per_page && max_per_page < n
#      limit(max_per_page).offset(offset_value / limit_value * max_per_page)
#    else
#      limit(n).offset(offset_value / limit_value * n)
#    end
#  end
#  def padding(num)
#    @_padding = num
#    offset(offset_value + num.to_i)
#  end
#  # Total number of pages
#  def total_pages
#    count_without_padding = total_count
#    count_without_padding -= @_padding if defined?(@_padding) && @_padding
#    count_without_padding = 0 if count_without_padding < 0
#    total_pages_count = (count_without_padding.to_f / limit_value).ceil
#    if max_pages.present? && max_pages < total_pages_count
#      max_pages
#    else
#      total_pages_count
#    end
#  rescue FloatDomainError => e
#    raise ZeroPerPageOperation, "The number of total pages was incalculable. Perhaps you called .per(0)?"
#  end
#  #FIXME for compatibility. remove num_pages at some time in the future
#  alias num_pages total_pages
#  # Current page number
#  def current_page
#    offset_without_padding = offset_value
#    offset_without_padding -= @_padding if defined?(@_padding) && @_padding
#    offset_without_padding = 0 if offset_without_padding < 0
#    (offset_without_padding / limit_value) + 1
#  rescue ZeroDivisionError => e
#    raise ZeroPerPageOperation, "Current page was incalculable. Perhaps you called .per(0)?"
#  end
#  # Next page number in the collection
#  def next_page
#    current_page + 1 unless last_page? || out_of_range?
#  end
#  # Previous page number in the collection
#  def prev_page
#    current_page - 1 unless first_page? || out_of_range?
#  end
#  # First page of the collection?
#  def first_page?
#    current_page == 1
#  end
#  # Last page of the collection?
#  def last_page?
#    current_page == total_pages
#  end
#  # Out of range of the collection?
#  def out_of_range?
#    current_page > total_pages
#  end
#end
#
#module NoBrainerModelExtension
#  extend ActiveSupport::Concern
#  included do
#    #self.send(:include, Kaminari::ConfigurationMethods)
#    # Fetch the values at the specified page number
#    #   Model.page(5)
#    eval <<-RUBY
#      def self.#{page}(num = nil)
#        all.limit(default_per_page).skip(default_per_page * ([num.to_i, 1].max - 1)).extending do
#          #include Kaminari::ActiveRecordRelationMethods
#          include PageScopeMethods
#        end
#      end
#    RUBY
#  end
#end
#
#module NoBrainerExtension  
#  extend ActiveSupport::Concern
#  included do
#    class << self
#      def inherited_with_kaminari(kls) #:nodoc:
#        inherited_without_kaminari kls
#        kls.send(:include, NoBrainerModelExtension) if kls.superclass == NoBrainer::Document
#      end
#      alias_method_chain :inherited, :kaminari
#    end
#
#    self.descendants.each do |kls|
#      kls.send(:include, NoBrainerModelExtension) if kls.superclass == NoBrainer::Document
#    end
#  end
#end
#
#module SexyPants
#  def sexy_pants
#    puts "Hey, my pants are sexy!"
#  end
#
#  def page(num=1)
#    default_per_page = 10
#    self.all.limit(default_per_page).skip(default_per_page * ([num.to_i, 1].max - 1))
#  end
#end

#  included do
#    class << self
#      def sexy_pants
#        puts "Hey, my pants are sexy!"
#      end
#    end
#  end
#end
#  module Paginatable
#
#    #self.define_singleton_method :page do |num|
#    #  num ||= 1
#    #  model = self
#    #  model = self.model if self.is_a? NoBrainer::Document
#    #  num = [num.to_i, 1].max - 1
#    #  all.skip(model.default_per_page * num).limit(model.default_per_page)
#    #end
#  
#    class_eval <<-RUBY, __FILE__, __LINE__ + 1
#      def self.page(num = 1)
#        model = self
#        model = self.model if self.is_a? NoBrainer::Document
#        num = [num.to_i, 1].max - 1
#        all.skip(model.default_per_page * num).limit(model.default_per_page)#.extend Paginating
#      end
#    RUBY
#  end
#end

class Observation
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  #extend SexyPants

  store_in :database => ENV['RETHINKDB_DB'], :table => 'Sighting'

  belongs_to :user
  belongs_to :animal

  field :id,          :type => String,      :as => 'SightingID',   :primary_key => true
  field :created_at,  :type => Time,        :as => 'CreatedDate'
  field :updated_at,  :type => Time,        :as => 'UpdatedDate'
  field :observed_at, :type => Integer,     :as => 'SightingDate'
  field :latitude,    :type => Float,       :as => 'Latitude'
  field :longitude,   :type => Float,       :as => 'Longitude'
  field :geom,                              :as => 'Geom'
  field :address,     :type => String,      :as => 'Location'
  field :image,       :type => String,      :as => 'ImageURL'
  field :animal_id,   :type => String,      :as => 'WildlifeID'

  def observed_at=(time)
    super(time.to_i * 1000)
  end

  def observed_at
    epoch_in_ms = super()
    puts "epoch_in_ms: #{epoch_in_ms}"
    if (epoch_in_ms)
      epoch_in_s = epoch_in_ms / 1000
      Time.at(epoch_in_s)
    else
      nil
    end
  end
end
