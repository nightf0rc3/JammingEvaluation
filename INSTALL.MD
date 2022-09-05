# Installation

MacOS

```
brew install boost
xcodebuild -license
xcode-select --install

sudo port install uhd
sudo port install gnuradio

sudo port install cppunit

# http://blog.jdlh.com/en/2015/01/25/pycdio_install_error_swig/
sudo port install swig
sudo port install swig-python

cmake ../ -DGR_PYTHON_DIR=/opt/local/Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages


sudo port install wireshark3 +lua
```