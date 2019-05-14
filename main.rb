require './src/parsers/lacounty_parser'
require './src/parsers/unicourt_parser'

id = 2156020111
link = 'https://unicourt.com/courts/state/los-angeles-county-superior-courts-6/probate'

lacountyInstance = LacountyParser.new(id)

# lacountyInstance.fetch()

unicourtInstance = UnicourtParser.new(link)

# unicourtInstance.fetch()