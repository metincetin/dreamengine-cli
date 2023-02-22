#!/bin/bash

sudo rm /usr/local/bin/dreamengine

cm='printf "#!/bin/sh\nhaxelib run dreamengine-cli \"\$@\"" >> /usr/local/bin/dreamengine'

sudo sh -c "$cm"

sudo chmod +x /usr/local/bin/dreamengine