# Write Your Own Rules


```yaml
rules:
- id: owasp.untrusted.deserialization.java.beans.XMLDecoder.readObject()
  message: |
    Dangerous function readObject() was found to be in use
  metadata:
    cwe: "CWE-502"
    owasp: "A8:2017-Insecure Deserialization"
    source-rule-url: https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html
  severity: ERROR
  patterns:
  - pattern-either:
    - pattern: |
        $XMLDECODER = new XMLDecoder(...);
        ...
        $XMLDECODER.readObject();  
  languages:
  - java
```