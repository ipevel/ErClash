SHELL := /bin/bash

.PHONY: android_arm64 android_amd64 android_arm windows macos linux

android_arm64:
	dart ./setup.dart android --arch arm64

android_amd64:
	dart ./setup.dart android --arch amd64

android_arm:
	dart ./setup.dart android --arch arm

windows:
	dart ./setup.dart windows

macos:
	dart ./setup.dart macos

linux:
	dart ./setup.dart linux
