#!/bin/bash
# Flutter download karna
git clone https://github.com/flutter/flutter.git -b stable
# Path set karna
export PATH="$PATH:`pwd`/flutter/bin"
# Build banana
flutter build web --release