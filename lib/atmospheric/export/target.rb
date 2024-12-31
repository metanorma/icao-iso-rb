require "yaml"

module Atmospheric
  module Export
    module Target
      def round_to_sig_figs(num, num_sig_figs)
        num.round(num_sig_figs - Math.log10(num).ceil).to_f
      end

      def m_to_ft(meters)
        meters / 0.3048
      end

      def ft_to_m(feet)
        feet * 0.3048
      end

      def to_file(hash = to_yaml)
        File.write(filename, hash)
      end
    end
  end
end
