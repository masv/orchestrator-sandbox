# orchestrator-sandbox

This is a Vagrant setup for experimenting with Orchestrator. It is loosely
based on the Vagrant setup included in the official Orchestrator repo.

The `Vagrantfile` has five nodes, one node `admin` for Orchestrator and four
MySQL (Percona) nodes db1-db4 which form a replication topology automatically
on `vagrant up`.

## Notes

* Replication is row-based (RBR) and GTID is enabled
* The MySQL `root` password is `root`.
* The replication user is `repl` with password `vagrant_repl`.
* Orchestrator web UI is port forwarded as port 13000 on the host machine.
