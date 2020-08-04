# RealmCrud
A simple app to exercise crud executing using realm

how to setup Realm
1. in Application class, init Realm and set the default configuration
2. in Activity class, get the default instance
3. When using executeTransactionAsync, realm instance should be used from the one on another thread realm
