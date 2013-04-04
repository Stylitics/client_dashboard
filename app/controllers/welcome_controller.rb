class WelcomeController < ApplicationController
  def index
    sample_size = 10
    R.eval "x <- rnorm(#{sample_size})"
    R.eval "sd(x)"
    @lorem = R.pull 'x'
    # @lorem = "Hello without R"
  end
end
