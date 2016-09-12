require 'nem_nis/rest_utils'

module NemNis
  module Utils
    include NemNis::RestUtils
    module_function

    def nodes
      r = RestUtils.get "http://www.nodeexplorer.com/api_openapi_version"
      r["nodes"]
    end

  end
end
