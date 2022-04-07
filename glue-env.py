import sys
import os
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import importlib

import pandas as pd
import boto3

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

print("Python Version: {}".format(sys.version_info))
print("Path: {}".format(sys.path))
print("CWD: {}".format(os.getcwd()))
print("DIR LS: {}".format(os.listdir('.')))
print("Python Path: {}".format(os.environ['PYTHONPATH']))

print ("Boto3 version: {}".format(boto3.__version__))
print ("Pandas version: {}".format(pd.__version__))

es_spec = importlib.util.find_spec("elasticsearch")
if es_spec is not None:
    print("Found elasticsearch: {}".format (es_spec))
    import elasticsearch
    print("ElasticSearch version: {}".format (elasticsearch.__version__))
else:
    print("ElasticSearch is not found")

eland_spec = importlib.util.find_spec("eland")
if eland_spec is not None:
    print("Found eland: {}".format (eland_spec))
    import eland
    print("eland version: {}".format (eland.__version__))
else:
    print("eland is not found")

pyarrow_spec = importlib.util.find_spec("pyarrow")
if pyarrow_spec is not None:
    print("Found pyarrow: {}".format (pyarrow_spec))
    import pyarrow
    print("pyarrow version: {}".format (pyarrow.__version__))
else:
    print("pyarrow is not found")