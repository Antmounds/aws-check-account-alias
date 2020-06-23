# AWS Account Alias Checker
This tool checks the aws account alias every 5 min and attempts to change it to the `goal_account_alias`.

## Instructions
The only settings that need to be changed are in the `variables.tf` file. Add the desired account alias and update the phone number to receive an SMS to on successful change. Function results are logged to Cloudwatch.

#### Option A
```
$ git clone https://gitlab.com/antmounds/aws-account-alias-checker.git  # clones repo to current local directory
$ terraform init                # downloads plugins and providers
$ terraform plan                # displays the resources to be created/updated/destroyed
$ terraform apply                 # launches function, scheduled event, and permissions resources
```
#### Option B
```
$ git clone https://gitlab.com/antmounds/aws-account-alias-checker.git  # clones repo to current local directory
$ ./deploy.sh                 # zips and runs terraform init, plan, and deploy
```
#### Variables - `variables.tf`
| *name* | *description* |
| ------ | ------ |
| **goal_account_alias** | the goal account alias |
| **app_name** | Name of this lambda function. |
| **goal_account_alias** | The account alias that is desired |
| **owner** | Email of service owner in case of notifications |
| **notification_number** | The number to send an SMS to on success |
| **region** | The AWS region to create everything in |

### File tree
```
.
├── deploy.sh
├── lambda_function_payload.zip
├── lambda_function.rb
├── main.tf
├── output.tf
├── variables.tf
├── LICENSE
└── README.md

0 directories, 8 files
```
*generated with `$ tree --dirsfirst`* 

## Contributing
Pull requests, forks and stars are 太棒了 and mucho appreciatado!

- #### Get official Antmounds gear!
	<a href="https://streamlabs.com/Antmounds/#/merch">
		<img src="https://cdn.streamlabs.com/merch/panel8.png" width="160">
	</a>
	<a href="https://shop.spreadshirt.com/Antmounds">
		<img src="https://image.spreadshirtmedia.com/content/asset/sprd-logo_horizontal.svg" width="160">
	</a>

## Get in touch
* :speaking_head: Join the Antmounds [discord](https://discord.gg/VtFkvSv) server for more discussion and support on this project.

### MIT License
Copyright 2020-present Antmounds.com, Inc. or its affiliates. All Rights Reserved.

>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

>THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.