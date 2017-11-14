#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Diaspora
  require "diaspora/camo"
  require "diaspora/exceptions"
  require "diaspora/exporter"
  require "diaspora/federated"
  require "diaspora/federation"
  require "diaspora/fetcher"
  require "diaspora/markdownify"
  require "diaspora/mentionable"
  require "diaspora/message_renderer"
  require "diaspora/parser"

	include Diaspora::Camo
	include Diaspora::Exceptions
	include Diaspora::Exporter
	include Diaspora::Federated
	include Diaspora::Federation
	include Diaspora::Fetcher
	include Diaspora::Markdownify
	include Diaspora::Mentionable
	include Diaspora::MessageRender
	include Diaspora::Parser
end
