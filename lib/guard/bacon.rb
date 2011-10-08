# encoding: utf-8

require 'bacon'
require 'guard'
require 'guard/guard'
require 'guard/guard-bacon/version'

module Guard
  class Bacon < Guard

    def initialize(watchers= [], options= {})
      super
      if options[:output]
        puts "Bacon: Using output #{options[:output]}."
        ::Bacon.extend(::Bacon::const_get(options[:output]))
      end
      
      if options[:backtrace]
        puts "Bacon: Limiting backtrace to #{options[:backtrace]} lines."
        ::Bacon.backtrace_size = options[:backtrace]
      end
    end

    def start
      puts "Guard::Bacon started."
      true
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
      true
    end

    # Called on Ctrl-Z signal
    def reload
      true
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      Dir["specs/**/*_spec.rb"].each do |path|
        run_spec(path)
      end
      
      true
    end
    
    def run_spec(path)
      if File.exists?(path)
         pid = Kernel.fork do
           puts "\n●●➤  Running spec: #{path}"
           counters = ::Bacon.run_file(path)
           # system "bundle exec bacon -o TestUnit #{path}"
           # {:installed_summary=>1, :specifications=>19, :depth=>0, :requirements=>30, :failed=>2, :errors => 1}
           
           all_specs = counters[:specifications]
           failed = counters[:failed].to_i + counters[:errors].to_i
           
           if failed > 0
             Notifier.notify("Specs: #{failed} Failures (#{all_specs} specs)",
                 :image => :failed,
                 :title => File.basename(path)
               )
           else
             Notifier.notify("Specs: OK (#{all_specs} specs)",
                 :image => :success,
                 :title => File.basename(path)
               )
           end
         end
         
         Process.wait(pid)
       else
         puts "spec not found: #{path}"
       end
    end
    
    def file_changed(path)
      run_spec(path)
      puts ""
    end
    
    # Called on file(s) modifications
    def run_on_change(paths)
      paths.each do |path|
        file_changed(path)
      end
    end

  end
end
