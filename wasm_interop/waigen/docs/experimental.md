# Experimental Features being considered
- Reading WAT from standard input.
    ```bash
    cat main.wat | dart run waigen --stdin
    ```

- Mixing configurations:
  
  To do this, you should not pass any flags at all to the tool, and instead denote in the config file
    ```yaml
    type: mixed
    mixed:
      - c
      - dart2wasm

    dart2wasm:
      generate_for:

    c:
      generate_for:
    ```

    ```bash
    dart run waigen
    ```