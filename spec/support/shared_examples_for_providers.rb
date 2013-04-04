shared_examples_for 'Airbrake integrated error handler' do
  context 'uncaught in a controller' do
    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify_or_ignore)
      expect { get '/widgets/bubble_up' }.to raise_error(RuntimeError, 'bubble_up')
    end
  end

  context 'caught and reported in a controller' do
    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify_or_ignore)
      WidgetsController.any_instance.stub(:airbrake_local_request?).and_return(false)
      expect { get '/widgets/catch' }.to_not raise_error(RuntimeError)
    end
  end

  context 'uncaught in a model' do
    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify_or_ignore)
      expect { get '/widgets/deep_bubble_up' }.to raise_error(RuntimeError, 'deep_bubble_up')
    end
  end

  context 'caught and reported in a model' do
    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify)
      expect { get '/widgets/deep_catch' }.to_not raise_error(RuntimeError)
    end
  end
end

shared_examples_for 'Rollbar integrated error handler' do
  context 'uncaught in a controller' do
    it 'reports the error to Rollbar' do
      # TODO why is this firing twice in tests? once in ActionDispatch and once in Test Session
      Rollbar.should_receive(:report_exception).twice.and_return({})
      expect { get '/widgets/bubble_up' }.to raise_error(RuntimeError, 'bubble_up')
    end
  end

  context 'caught and reported in a controller' do
    it 'reports the error to Rollbar' do
      Rollbar.should_receive(:report_exception)
      expect { get '/widgets/catch' }.to_not raise_error(RuntimeError)
    end
  end

  context 'uncaught in a model' do
    it 'reports the error to Rollbar' do
      # TODO why is this firing twice in tests? once in ActionDispatch and once in Test Session
      Rollbar.should_receive(:report_exception).twice.and_return({})
      expect { get '/widgets/deep_bubble_up' }.to raise_error(RuntimeError, 'deep_bubble_up')
    end
  end

  context 'caught and reported in a model' do
    it 'reports the error to Rollbar' do
      Rollbar.should_receive(:report_exception)
      expect { get '/widgets/deep_catch' }.to_not raise_error(RuntimeError)
    end
  end
end

