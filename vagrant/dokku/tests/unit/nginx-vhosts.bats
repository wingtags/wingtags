#!/usr/bin/env bats

load test_helper

setup() {
  [[ -f "$DOKKU_ROOT/VHOST" ]] && cp -f "$DOKKU_ROOT/VHOST" "$DOKKU_ROOT/VHOST.bak"
  [[ -f "$DOKKU_ROOT/HOSTNAME" ]] && cp -f "$DOKKU_ROOT/HOSTNAME" "$DOKKU_ROOT/HOSTNAME.bak"
  create_app
}

teardown() {
  destroy_app
  [[ -f "$DOKKU_ROOT/VHOST.bak" ]] && mv "$DOKKU_ROOT/VHOST.bak" "$DOKKU_ROOT/VHOST"
  [[ -f "$DOKKU_ROOT/HOSTNAME.bak" ]] && mv "$DOKKU_ROOT/HOSTNAME.bak" "$DOKKU_ROOT/HOSTNAME"
  disable_tls_wildcard
}

assert_ssl_domain() {
  local domain=$1
  assert_app_domain "${domain}"
  assert_http_redirect "http://${domain}" "https://${domain}/"
  assert_http_success "https://${domain}"
}

assert_nonssl_domain() {
  local domain=$1
  assert_app_domain "${domain}"
  assert_http_success "http://${domain}"
}

assert_app_domain() {
  local domain=$1
  run /bin/bash -c "dokku domains $TEST_APP | grep -xF ${domain}"
  echo "output: "$output
  echo "status: "$status
  assert_output "${domain}"
}

assert_http_redirect() {
  local from=$1
  local to=$2
  run curl -kSso /dev/null -w "%{redirect_url}" "${from}"
  echo "output: "$output
  echo "status: "$status
  assert_output "${to}"
}

assert_http_success() {
  local url=$1
  run curl -kSso /dev/null -w "%{http_code}" "${url}"
  echo "output: "$output
  echo "status: "$status
  assert_output "200"
}

@test "nginx (no server tokens)" {
  deploy_app
  run /bin/bash -c "curl -s -D - $(dokku url $TEST_APP) -o /dev/null | egrep '^Server' | egrep '[0-9]+'"
  echo "output: "$output
  echo "status: "$status
  assert_failure
}

@test "nginx:build-config (wildcard SSL)" {
  setup_test_tls_wildcard
  add_domain "wildcard1.dokku.me"
  add_domain "wildcard2.dokku.me"
  add_domain "www.test.dokku.me"
  deploy_app
  assert_ssl_domain "wildcard1.dokku.me"
  assert_ssl_domain "wildcard2.dokku.me"
  assert_nonssl_domain "www.test.dokku.me"
}

@test "nginx:build-config (with SSL CN mismatch)" {
  setup_test_tls
  deploy_app
  assert_ssl_domain "node-js-app.dokku.me"
}

@test "nginx:build-config (with SSL and Multiple SANs)" {
  setup_test_tls_with_sans
  deploy_app
  assert_ssl_domain "test.dokku.me"
  assert_ssl_domain "www.test.dokku.me"
  assert_ssl_domain "www.test.app.dokku.me"
}

@test "nginx:build-config (no global VHOST and domains:add)" {
  destroy_app
  rm "$DOKKU_ROOT/VHOST"
  create_app
  add_domain "www.test.app.dokku.me"
  deploy_app
  assert_nonssl_domain "www.test.app.dokku.me"
}
