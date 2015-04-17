#!/usr/bin/env bats

load test_helper

setup() {
  export DOKKU_HOST=dokku.me
  create_app
}

teardown() {
  destroy_app
  unset DOKKU_HOST
}

@test "dokku client (unconfigured DOKKU_HOST)" {
  unset DOKKU_HOST
  run ./contrib/dokku_client.sh apps
  echo "output: "$output
  echo "status: "$status
  assert_exit_status 20
}

@test "dokku client (no args should print help)" {
  run /bin/bash -c "./contrib/dokku_client.sh | head -1 | egrep -q '^Usage: dokku \[.+\] COMMAND <app>.*'"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "dokku client (apps:create AND apps:destroy)" {
  setup_client_repo
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/dokku_client.sh apps:create"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/dokku_client.sh --force apps:destroy"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "dokku client (config:set)" {
  run ./contrib/dokku_client.sh config:set $TEST_APP test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run /bin/bash -c "./contrib/dokku_client.sh config:get $TEST_APP test_var2 | grep -q 'hello world'"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "dokku client (config:unset)" {
  run ./contrib/dokku_client.sh config:set $TEST_APP test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run ./contrib/dokku_client.sh config:get $TEST_APP test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run ./contrib/dokku_client.sh config:unset $TEST_APP test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run /bin/bash -c "./contrib/dokku_client.sh config:get $TEST_APP test_var | grep test_var"
  echo "output: "$output
  echo "status: "$status
  assert_failure
}

@test "dokku client (domains)" {
  run bash -c "./contrib/dokku_client.sh domains $TEST_APP | grep -q ${TEST_APP}.dokku.me"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "dokku client (domains:add)" {
  run ./contrib/dokku_client.sh domains:add $TEST_APP www.test.app.dokku.me
  echo "output: "$output
  echo "status: "$status
  assert_success
  run ./contrib/dokku_client.sh domains:add $TEST_APP test.app.dokku.me
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "dokku client (domains:remove)" {
  run ./contrib/dokku_client.sh domains:add $TEST_APP test.app.dokku.me
  echo "output: "$output
  echo "status: "$status
  assert_success
  run ./contrib/dokku_client.sh domains:remove $TEST_APP test.app.dokku.me
  echo "output: "$output
  echo "status: "$status
  refute_line "test.app.dokku.me"
}

@test "dokku client (domains:clear)" {
  run ./contrib/dokku_client.sh domains:add $TEST_APP test.app.dokku.me
  echo "output: "$output
  echo "status: "$status
  assert_success
  run ./contrib/dokku_client.sh domains:clear $TEST_APP
  echo "output: "$output
  echo "status: "$status
  assert_success
}

# @test "dokku client (ps)" {
#   # CI support: 'Ah. I just spoke with our Docker expert --
#   # looks like docker exec is built to work with docker-under-libcontainer,
#   # but we're using docker-under-lxc. I don't have an estimated time for the fix, sorry
#   skip "circleci does not support docker exec at the moment."
#   deploy_app
#   run bash -c "${BATS_TEST_DIRNAME}/../../contrib/dokku_client.sh ps $TEST_APP | grep -q 'node web.js'"
#   echo "output: "$output
#   echo "status: "$status
#   assert_success
# }

@test "dokku client (ps:start)" {
  deploy_app
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/dokku_client.sh ps:stop $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/dokku_client.sh ps:start $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "docker ps -q --no-trunc | grep -q $(< $DOKKU_ROOT/$TEST_APP/CONTAINER)"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "dokku client (ps:stop)" {
  deploy_app
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/dokku_client.sh ps:stop $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "docker ps -q --no-trunc | grep -q $(< $DOKKU_ROOT/$TEST_APP/CONTAINER)"
  echo "output: "$output
  echo "status: "$status
  assert_failure
}

@test "dokku client (ps:restart)" {
  deploy_app
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/dokku_client.sh ps:restart $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "docker ps -q --no-trunc | grep -q $(< $DOKKU_ROOT/$TEST_APP/CONTAINER)"
  echo "output: "$output
  echo "status: "$status
  assert_success
}
