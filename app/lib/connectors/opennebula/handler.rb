# frozen_string_literal: true

module Connectors
  module Opennebula
    class Handler
      include Helper
      attr_reader :client
      attr_accessor :pool

      def initialize
        @client = OpenNebula::Client.new Rails.configuration.keystorm['opennebula']['secret'],
                                         Rails.configuration.keystorm['opennebula']['endpoint']
      end

      def find_one(xpaths = {})
        find(:find, xpaths)
      end

      def find_all(xpaths = {})
        find(:find_all, xpaths)
      end

      def find_by_name(name)
        find_one('NAME' => name)
      end

      def find_by_id(id)
        find_one('ID' => id.to_s)
      end

      def exist?(id)
        find_by_id id
      end

      private

      def find(method, xpaths = {})
        reload!

        pool.send(method) do |element|
          (respond_to?(:exclude) ? !exclude.include?(element.name) : true) && evaluate_xpaths(element, xpaths)
        end
      end

      def evaluate_xpaths(element, xpaths)
        xpaths.inject(true) do |red, elem|
          red && (elem.last.is_a?(Array) ? elem.last.include?(element[elem.first]) : element[elem.first] == elem.last)
        end
      end

      def reload!
        raise Errors::Connectors::Opennebula::MissingPoolError, 'Handler is missing an OpenNebula pool' unless pool

        method = pool.respond_to?('info_all!') ? 'info_all!' : 'info!'
        handle_opennebula_error { pool.send(method.to_sym) }
      end
    end
  end
end
