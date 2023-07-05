package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()
	randID := strings.ToLower(random.UniqueId())
	attributes := []string{randID}

	// name is here more as an example rather than as a useful test input
	name := "rds-alarms"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		// We always include a random attribute so that parallel tests
		// and AWS resources do not interfere with each other
		Vars: map[string]interface{}{
			"attributes": attributes,
			"name":       name,
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	snsTopicArn := terraform.Output(t, terraformOptions, "rds_alarms_sns_topic_arn")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, fmt.Sprintf("arn:aws:sns:us-east-2:%s:%s-%s-%s-%s-%s",
		aws.GetAccountId(t),
		"eg",
		"test",
		name,
		randID,
		"rds-threshold-alerts"), snsTopicArn)

	rdsArn := terraform.Output(t, terraformOptions, "rds_instance_id")
	assert.Equal(t, fmt.Sprintf("eg-test-rds-alarms-%s", randID), rdsArn)
}
