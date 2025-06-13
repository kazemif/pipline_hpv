from setuptools import setup, find_packages

setup(
    name='parse_read_align',
    version='0.1',
    packages=find_packages(),
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'parse_read_align=parse_read_align.main:main',
        ],
    },
)