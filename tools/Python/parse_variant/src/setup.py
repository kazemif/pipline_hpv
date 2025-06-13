from setuptools import setup, find_packages

setup(
    name='parse_variant',
    version='1.0',
    packages=find_packages(),
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'parse_variant=parse_variant.main:main',
        ],
    },
)