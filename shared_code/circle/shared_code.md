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
aws-vault exec sirius-dev -- aws codeartifact login --tool twine \
--repository opg-pip-shared-code-dev --domain opg-moj --domain-owner 288342028542 --region eu-west-1
```

Upload to a repo

```
python3 -m twine upload --repository codeartifact dist/*
```

Login to repo to be able to pull

```
aws-vault exec sirius-dev -- aws codeartifact login --tool pip \
--repository opg-pip-shared-code-dev --domain opg-moj --domain-owner 288342028542 --region eu-west-1
```

Pull using pip in the usual way

```
pip3 install opg_integrations_shared==0.0.1
```

No terraform code artifact yet (but coming very soon):

https://github.com/terraform-providers/terraform-provider-aws/issues/13714
