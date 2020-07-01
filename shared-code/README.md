This is a simple example package. You can use
[Github-flavored Markdown](https://guides.github.com/features/mastering-markdown/)
to write your content.

To upload your own python packages to code artifact and then use them, you should follow these instructions.

Install wheel for packaging

```
python3 -m pip install --user --upgrade setuptools wheel
```

Package your distribution

```
python3 setup.py sdist bdist_wheel
```

Install twine for publishing

```
python3 -m pip install --user --upgrade twine
```

Login for publishing

```
aws-vault exec sandbox -- aws codeartifact login --tool twine \
--repository jim_test --domain opg-moj --domain-owner 995199299616 --region eu-west-1
```

arn:aws:kms:eu-west-1:995199299616:key/91efc530-178d-4055-9d6f-51dc644b8634

Upload to a repo

```
python3 -m twine upload --repository codeartifact dist/*
```

Login to repo for pull

```
aws-vault exec sandbox -- aws codeartifact login --tool pip \
--repository jim_test --domain opg-moj --domain-owner 995199299616 --region eu-west-1
```

No terraform code artifact yet (but coming very soon):

https://github.com/terraform-providers/terraform-provider-aws/issues/13714
