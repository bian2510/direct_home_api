ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(DirectHomeApi.Repo, :manual)
Mox.defmock(DirectHomeApi.Aws.MockS3, for: DirectHomeApi.Aws.S3)
