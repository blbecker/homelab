# Homelab Flux

Flux-enabled kubernetes deployment of my homelab.

[Detailed docs](https://blbecker.github.io/homelab-flux/)

Bootstrap Command: `flux bootstrap github --token-auth=false --owner blbecker --repository homelab --branch main --path=flux/clusters/tartarus.us`

## Secrets

Two mechanisms for handling secrets are available. `dotenvx` handles secret environment variables and ejson handles secrets that can be consumed from json, right now that's just terraform variables, but can be used for other things too.

### Encryption

This project uses `lefthook` and declares an encryption step in `lefthook.yml`. `ejson` and `dotenvx` both use asymmetric encryption, so encryption does not require access to secrets. Commands below are provided for reference, because I use lefthook everywhere.

```bash
ejson e terraform/secrets.tfvars.ejson && \
dotenvx encrypt
```

### Decrypt ejson secrets

Ejson secrets are decrypted to a file for consumption by terragrunt. The decryption key for ejson is held in `dotenvx`, so the whole chain can be unlocked with the `dotenvx` private key (passed as an environment variable in CI).

```bash
# Decrypt secrets with envvar (how CI does it)
dotenvx get EJSON_PRIVATE_KEY | ejson decrypt --key-from-stdin terraform/secrets.tfvars.ejson > terraform/secrets.tfvars.json

# Decrypt secrets with a key from $EJSON_KEYDIR
ejson decrypt terraform/secrets.tfvars.ejson -o terraform/secrets.tfvars.json

```

## Terragrunt

Plan changes.

```bash
dotenvx run -- terragrunt --working-dir terraform plan --all
```

Apply changes.

```bash
dotenvx run -- terragrunt --working-dir terraform apply --all
```
