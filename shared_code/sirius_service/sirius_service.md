create correct folder structure



create a venv

```
cd shared_code
pip3 install -r requirements
```


package your code up

```
python3 setup.py sdist bdist_wheel
```


login to publish:

```
aws-vault exec [[your aws identity here]] -- aws codeartifact login --tool twine --repository opg-pip-shared-code-dev --domain opg-moj --domain-owner 288342028542 --region eu-west-1
```
