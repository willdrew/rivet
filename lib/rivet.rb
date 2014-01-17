require 'aws-sdk'
require 'base64'
require 'digest/sha1'
require 'erb'
require 'json'
require 'logger'
require 'optparse'
require 'ostruct'
require 'singleton'

require_relative 'rivet/autoscale'
require_relative 'rivet/aws_autoscale_wrapper'
require_relative 'rivet/aws_utils'
require_relative 'rivet/bootstrap'
require_relative 'rivet/client'
require_relative 'rivet/config'
require_relative 'rivet/config_proxy'
require_relative 'rivet/deep_merge'
require_relative 'rivet/launch_config'
require_relative 'rivet/logger'
require_relative 'rivet/utils'
