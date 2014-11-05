module Roku
  module Iap
    module Exceptions
      class Exception < Exception; end
      class General < Roku::Iap::Exceptions::Exception; end
      class InvalidCredentials < Roku::Iap::Exceptions::Exception; end
      class TypeError < Roku::Iap::Exceptions::Exception; end
    end
  end
end