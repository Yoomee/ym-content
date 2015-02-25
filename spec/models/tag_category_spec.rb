require 'spec_helper'

describe TagCategory do

  it { should have_many(:content_types) }

end
