require 'spec_helper'

describe(Roda::RodaPlugins::Controller) do
  class Hello
    def world
      "Hello World"
    end
  end

  class Ola
    def mundo
      "Olá Mundo"
    end
  end

  it "registers controllers via controllers: option" do
    app(controllers: Hello) { |r| r.get { dispatch("hello#world") } }

    get "/"

    expect(last_response).to be_ok
    expect(last_response.body).to eql "Hello World"
  end

  it "registers multiple controllers via controllers: option" do
    app(controllers: [Hello, Ola]) do |r|
      r.get('hi') { dispatch("hello#world") }
      r.get('ola') { dispatch("ola#mundo") }
    end

    get "/hi"

    expect(last_response).to be_ok
    expect(last_response.body).to eql "Hello World"

    get "/ola"

    expect(last_response).to be_ok
    expect(last_response.body).to eql "Olá Mundo"
  end

  it "registers controllers via controllers: option" do
    app(controllers: Hello) { |r| r.get { dispatch("hello#world") } }

    get "/"

    expect(last_response).to be_ok
    expect(last_response.body).to eql "Hello World"
  end

  it "registers class controllers via .register_controller" do
    app { |r| r.get { dispatch("hello#world") } }
    app.register_controller(Hello)

    get "/"

    expect(last_response).to be_ok
    expect(last_response.body).to eql "Hello World"
  end

  it "registers class controllers via .register_controller with specific key" do
    app { |r| r.get { dispatch("hi#world") } }
    app.register_controller(:hi, Hello)

    get "/"

    expect(last_response).to be_ok
    expect(last_response.body).to eql "Hello World"
  end
end
