require 'forwardable'
require 'exogenesis/support/executor'
require 'exogenesis/support/monkey_patch'

class Passenger
  extend Forwardable

  @passengers = {}
  @emoji_name = :alien #default

  class << self
    attr_accessor :passengers
    attr_reader :emoji_name

    def by_name(name)
      passengers[name]
    end

    def [](name)
      by_name name
    end

    def register_as(name)
      if Passenger.passengers.has_value? self
        Passenger.passengers.delete Passenger.passengers.rassoc(self).first
      end
      Passenger.passengers[name.to_s] = self
    end

    def needs(config_name)
      def_delegator :@config, config_name
    end

    def with_emoji(emoji_name)
      @emoji_name = emoji_name
    end

    def inherited(child)
      @passengers[child.class.name.underscore] = child
    end

  end

  def_delegators :@executor,
                 :start_section,
                 :start_task,
                 :task_succeeded,
                 :task_failed,
                 :skip_task,
                 :info,
                 :mkpath,
                 :get_path_in_home,
                 :get_path_in_working_directory,
                 :get_path_for,
                 :execute,
                 :execute_interactive,
                 :silent_execute,
                 :ln_s,
                 :rm_rf,
                 :ask?,
                 :clone_repo,
                 :pull_repo,
                 :command_exists?

  def initialize(config, executor = Executor.instance)
    @config = config
    @executor = executor
  end
end
