This directory was created to experiment with putting multiple Python modules into a Zip file so that a single Zip file could be referenced as part of a Glue job specification (vs listing each module individually).  

The steps followed are based on materials found at:
https://stackoverflow.com/questions/2915471/install-a-python-package-into-a-different-directory-using-pip
https://medium.com/@bv_subhash/sharing-re-usable-code-across-multiple-aws-glue-jobs-290e7e8b3025

command log:
```
mkdir -p module-dist/utilities
cat >>setup.py <EOF
from setuptools import setup
setup(
    name="utilities",
    version="0.1",
    packages=['utilities']
)
EOF

# from within an Amazon Linux 2 container with the mudule-dist mapped to /opt in the container
pip install --target==/opt/utilities pyarrow pandas==1.1.5 elasticsearch eland

# next from outside the container
python3 setup.py bdist_wheel
aws s3 cp dist/utilities-0.1-py3-none-any.whl s3://aws-glue-assets-776347453069-eu-west-2/utilities.whl

touch utilities/__init__.py
cd utilities
zip -r -X ../dependencies.zip *

