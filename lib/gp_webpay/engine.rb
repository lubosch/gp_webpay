if Object.const_defined?(:Rails)
  module GpWebpay
    class Engine < ::Rails::Engine
      isolate_namespace GpWebpay
    end
  end
end
