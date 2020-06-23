require 'aws-sdk-iam'
require 'aws-sdk-lambda'
require 'aws-sdk-sns'
require 'json'


def lambda_handler(event:, context:)
    goal_account_alias = ENV['GOAL_ACCOUNT_ALIAS']
    iam = Aws::IAM::Client.new()
    
    resp = iam.list_account_aliases({})
    msg = "Lambda Attempting Account Alias Change"
    result = "\n#{DateTime.parse(event['time']).strftime("%B %d, %Y - %H:%M:%S")}\n"
    result += "\n### - Current IAM Account Alias: "
    result += JSON.pretty_generate(resp.account_aliases[0]) + "\n\n"
    begin
        if resp.account_aliases[0] != goal_account_alias
            result += "### - Attempting Account Alias Change to '#{goal_account_alias}'\n"
            resp = iam.create_account_alias({
              account_alias: goal_account_alias, 
            })
            # send a text message if it's successful
            msg = "Your IAM account alias has been successfully changed to 'antmounds'!😎"
            sns = Aws::SNS::Resource.new()
            topic = sns.topic(ENV['SNS_TOPIC_ARN'])
            topic.publish({
              message: msg
            })
            # Disable the function by setting it to 0 concurrency now that achieved account alias is set
            lambda_client = Aws::Lambda::Client.new()
            res = lambda_client.put_function_concurrency({function_name: context.function_name, reserved_concurrent_executions: 0})
            result += "\nnew concurrency: #{res[:reserved_concurrent_executions]}\n\n"
        else
            msg = "Current IAM alias is already the goal alias!!\n\n"
            result += msg
        end
    rescue Exception => e
        msg = e.message
        result += "\n#{msg}\n"
        # puts e.backtrace.inspect
    else
        # other exception
        result += "#{resp}\n\n.....success!"
    ensure
        # always executed
        result += "\nFINISHED!!!\n\n"
        puts result
        return { statusCode: 200, body: msg }
    end
end