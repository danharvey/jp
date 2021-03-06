#!/usr/bin/env ruby

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../gen-rb/'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/./gen-rb/'
require 'job_pool'
require_relative './client.rb'

autoload :JSON, 'json'

module Jp
	class AbstractProducer < AbstractClient
		def initialize queue, options = {}
			super queue, options
		end
		def add message
			@client.add @queue, translate(message)
		end
		private
		def translate message
			raise NotImplementedError.new
		end
	end

	class TextProducer < AbstractProducer
		private
		def translate message
			message
		end
	end

	class JsonProducer < AbstractProducer
		private
		def translate message
			JSON::dump message
		end
	end

	class ThriftProducer < AbstractProducer
		def initialize queue, options = {}
			super queue, options
			@serializer = Thrift::Serializer.new
		end
		private
		def translate message
			@serializer.serialize message
		end
	end
end
