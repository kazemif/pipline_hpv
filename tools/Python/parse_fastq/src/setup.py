from setuptools import setup, find_packages

setup(
    name='parse_fastq',
    version='0.1',
    packages=find_packages(),
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'parse_fastq=parse_fastq.main:main',
        ],
    },
)