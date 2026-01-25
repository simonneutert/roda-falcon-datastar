# frozen_string_literal: true

# Starting point of our new roda app.
class App < Roda
  plugin :render
  plugin :partials
  plugin :streaming

  route do |r| # rubocop:disable Metrics/BlockLength
    # GET / request
    r.root do
      r.redirect '/datastar'
    end

    # Create a Datastar::Dispatcher instance
    # in Roda all paths below can use the `datastar` instance
    datastar = Datastar.new(request: request, response: response)

    r.on 'datastar' do
      @items = DB[:items]
      @items_count = @items.count

      view 'datastar'
    end

    r.on 'hal-status' do
      render 'hal-status'
    end

    r.on 'counter' do
      r.on 'reset' do
        datastar.stream do |sse|
          sleep 5
          sse.patch_signals({ counter: 0 })
        end
        r.halt(datastar.response.to_a)
      end
      r.is do
        c = r.params['counter'].to_i
        datastar.stream do |sse|
          sse.patch_signals({ counter: c + 1 })
        end
        r.halt(datastar.response.to_a)
      end
    end

    r.on 'countdown-sse' do
      # In a Rack handler, you can instantiate from the Rack env
      # datastar = Datastar.from_rack_env(env)

      # Start a streaming response
      datastar.stream do |sse|
        (1..10).to_a.reverse_each do |i|
          sse.patch_elements %(<div id="countdown">#{i}</div>)
          sleep 1
        end

        # patch_elements: patches elements into the DOM.
        sse.patch_elements %(<div id="countdown">Are you happy?</div>)
        sleep 2
        sse.patch_elements %(<div id="countdown">Are you happy? I hope so.</div>)
        sleep 2
        sse.patch_elements %(<div id="countdown">Waiting for an order...</div>)
      end

      r.halt(datastar.response.to_a)
    end
  end
end
