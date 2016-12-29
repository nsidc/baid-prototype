# Read data from a local text file
module DStore
  class TSeries
    attr_reader :time_series

    def initialize(file_path)
      @time_series = {}
      if fh = File.new(file_path)
        @time_series['BW'] = {
          'E' => {
            'T1' => [],
            'T2' => []
          },
          'C' => {
            'T1' => [],
            'T2' => []
          }
        }

        @time_series['BD'] = {
          'E' => {
            'T1' => [],
            'T2' => []
          },
          'C' => {
            'T1' => [],
            'T2' => []
          }
        }

        File.foreach(fh) { |line|
          # The third element in the line identifies the site and community. Look
          # for Barrow (B), Wet (W) or Dry (D)
          if(/B[W|D]/.match(line.tr('"','').split( %r{\s+} )[3]))
            arr = line.tr('"','').split( %r{\s+} )
            data = { 'utc' => arr[0],
                     'local' => arr[1],
                     'julian' => arr[7].to_i,
                     'tempCa' => arr[10].to_f,
                     'temp0' => arr[11].to_f,
                     'temp5' => arr[12].to_f,
                     'temp10' => arr[13].to_f,
                     'temp15' => arr[14].to_f,
                     'temp30' => arr[15].to_f,
                     'temp45' => arr[16].to_f,
                     'wfv' => arr[17].to_f,
                     'nacl' => arr[18].to_f }
            @time_series[arr[3]][arr[4]][arr[5]] << data
          end
        }
      end
    end
  end
end
