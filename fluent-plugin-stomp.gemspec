# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fluent-plugin-stomp/version"

Gem::Specification.new do |s|
    s.name              = "fluent-plugin-stomp"
    s.version           = Fluent::Plugin::Stomp::VERSION
    s.authors           = ["Jiang Yang", "Guo Yong"]
    s.email             = ["jiangyang0323@gmail.com", "wolfg1969@gmail.com"]
    s.homepage          = "https://github.com/waterfox0323/fluent-plugin-stomp"
    s.summary           = "STOMP output plugin for fluentd"
    s.description       = %q"STOMP output plugin for fluentd"

    s.files             = `git ls-files`.split($\)
    s.executables       = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
    s.test_files        = s.files.grep(%r{^(test|spec|features)/})
    s.require_paths     = ["lib"]

    s.add_development_dependency "rake"
    s.add_development_dependency "fluentd"
    s.add_development_dependency "stomp"

    s.add_runtime_dependency "fluentd"
end
