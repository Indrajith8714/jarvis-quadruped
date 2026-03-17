import os
from glob import glob
from setuptools import find_packages, setup

package_name = 'jarvis_core'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        # This line ensures your launch files are copied during build
        (os.path.join('share', package_name, 'launch'), glob(os.path.join('launch', '*launch.[pxy][yma]*'))),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Indrajith8714',
    maintainer_email='indra8714nambrath@gmail.com',
    description='J.A.R.V.I.S. Core Control System',
    license='Apache License 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            # This links the command 'status_node' to your Python script
            'status_node = jarvis_core.status_node:main',
        ],
    },
)
