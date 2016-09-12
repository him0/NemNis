module NemNis
  class Node

    attr_reader :node_url

    def initialize(options = {})
      @use_super_node = true

      @host = "localshost"
      @port = 7890

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?

      if @use_super_node
        @node_uri = URI.parse("http://" + NemNis::Utils.nodes.sample)
        @host = @node_uri.host
        @port = @node_uri.port
      else
        @node_uri = URI.parse("http://#{@host}:#{@port}")
      end
    end

    def heartbeat(interpretion = true)
      request_uri = @node_uri
      request_uri.path = "/heartbeat"
      response = NemNis::RestUtils.get request_uri

      if interpretion
        response["type_mean"] = interprete_type(response["type"])
        response["code_mean"] = interprete_code(
          response["type"],
          response["code"]
        )
      end

      response
    end

    def status(interpretion = true)
      request_uri = @node_uri
      request_uri.path = "/status"
      response = NemNis::RestUtils.get request_uri

      if interpretion
        response["type_mean"] = interprete_type(response["type"])
        response["code_mean"] = interprete_code(
          response["type"],
          response["code"]
        )
      end

      response
    end

    private

    def interprete_type(type)
      if type == 1
        return "The result is a validation result."
      elsif type == 2
        return "The result is a heart beat result."
      elsif type == 4
        return "The result indicates a status."
      end
      "Undifined type."
    end

    def interprete_code(type, code)
      if type == 1
        return interprete_type1_code code
      elsif type == 2
        return interprete_type2_code code
      elsif type == 3
        return interprete_type3_code code
      elsif type == 4
        return interprete_type4_code code
      end
      "Undifined type code."
    end

    def interprete_type1_code(code)
      if code == 0
        return "Neutral result. A typical example would be that a node validates an incoming transaction and realizes that it already knows about the transaction. In this case it is neither a success (meaning the node has a new transaction) nor a failure (because the transaction itself is valid)."
      elsif code == 1
        return "Success result. A typical example would be that a node validates a new valid transaction."
      elsif code == 2
        return "Unknown failure. The validation failed for unknown reasons."
      elsif code == 3
        return "The entity that was validated has already past its deadline."
      elsif code == 4
        return "The entity used a deadline which lies too far in the future."
      elsif code == 5
        return "There was an account involved which had an insufficient balance to perform the operation."
      elsif code == 6
        return "The message supplied with the transaction is too large."
      elsif code == 7
        return "The hash of the entity which got validated is already in the database."
      elsif code == 8
        return "The signature of the entity could not be validated."
      elsif code == 9
        return "The entity used a timestamp that lies too far in the past."
      elsif code == 10
        return "The entity used a timestamp that lies in the future which is not acceptable."
      elsif code == 11
        return "The entity is unusable."
      elsif code == 12
        return "The score of the remote block chain is inferior (although a superior score was promised)."
      elsif code == 13
        return "The remote block chain failed validation."
      elsif code == 14
        return "There was a conflicting importance transfer detected."
      elsif code == 15
        return "There were too many transaction in the supplied block."
      elsif code == 16
        return "The block contains a transaction that was signed by the harvester."
      elsif code == 17
        return "A previous importance transaction conflicts with a new transaction."
      elsif code == 18
        return "An importance transfer activation was attempted while previous one is active."
      elsif code == 19
        return "An importance transfer deactivation was attempted but is not active."
      end
      "Undifined type code."
    end

    def interprete_type2_code(code)
      if code == 1
        return "Successful heart beat detected."
      end
      "Undifined type code."
    end

    def interprete_type3_code(code)
      if code == 0
        return "Unknown status."
      elsif code == 1
        return "NIS is stopped."
      elsif code == 2
        return "NIS is starting."
      elsif code == 3
        return "NIS is running."
      elsif code == 4
        return "NIS is booting the local node (implies NIS is running)."
      elsif code == 5
        return "The local node is booted (implies NIS is running)."
      elsif code == 6
        return "The local node is synchronized (implies NIS is running and the local node is booted)."
      elsif code == 7
        return "There is no remote node available (implies NIS is running and the local node is booted)."
      elsif code == 8
        return "NIS is currently loading the block chain."
      end
      "Undifined type code."
    end

    def interprete_type4_code(code)
      if code == 0
        return "Unknown status."
      elsif code == 1
        return "NIS is stopped."
      elsif code == 2
        return "NIS is starting."
      elsif code == 3
        return "NIS is running."
      elsif code == 4
        return "NIS is booting the local node (implies NIS is running)."
      elsif code == 5
        return "The local node is booted (implies NIS is running)."
      elsif code == 6
        return "NIS local node does not see any remote NIS node (implies running and booted)."
      elsif code == 7
        return "NIS local node does not see any remote NIS node (implies running and booted)."
      elsif code == 8
        return "NIS is currently loading the block chain from the database. In this state NIS cannot serve any requests."
      end
      "Undifined type code."
    end

  end
end
