#!/usr/bin/env bats

function teardown() {
    rm -f terraform.tfstate*
}

@test "Verification test - check if terraform produces a valid plan" {
    run terraform plan -no-color -input=false -detailed-exitcode --out tfplan.binary
    echo "$output"
    [ "$status" -eq 2 ]

    terraform show -no-color -json tfplan.binary > tfplan.json
}

@test "Verification test - check if instance is c5.large" { 
    run opa eval --format pretty --data verify.rego --input tfplan.json "data.devskiller.test_instance_type"
    echo "$output"
    [ "${lines[0]}" = "true" ]
}

@test "Verification test - check if it's possible to create an instance in us-east-1" { 
    AWS_DEFAULT_REGION="us-east-1" run terraform plan -var ami_id=ami-0885b1f6bd170450c -no-color -input=false -detailed-exitcode
    echo "$output"
    [ "$status" -eq 2 ]
}