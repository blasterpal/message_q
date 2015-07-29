module QueueHelpers
  def queue_defaults_hash
    :env => 'test',
    :durable => false,
    :ack => true,
    :threads => 50,
    :prefetch => 50,
    :timeout_job_after => 1,
    :exchange => 'dummy',
    :heartbeat => 5
  end
end
