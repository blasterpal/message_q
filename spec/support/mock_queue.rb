module MockQueue

  def mock_publish_adapter(message,message_options)
    xchg = Object.new
    routing_key = message_options.delete(:queue)

    double(xchg).publish(message_options.merge!(routing_key: routing_key))

    p = Sneakers::Publisher.new
    p.instance_variable_set(:@exchange, xchg)
    mock(p).ensure_connection! {}
    p
  end

end
