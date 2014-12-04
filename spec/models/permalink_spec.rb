require 'spec_helper'
require 'byebug'

describe Permalink do

  it { should validate_uniqueness_of(:full_path) }

end
