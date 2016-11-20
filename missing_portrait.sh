 #!/usr/bin/env bash

 find -E png/$1  -regex ".*character_[5|6][0-9]{3}_t1\.png" | sed 's/_5/_0/' | sed 's/_6/_1/' | sed 's/_t1/_c1/' | xargs -n1 ls