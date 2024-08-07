# Dex

_** WORK IN PROGRESS - DO NOT USE_

### Goals

- [x] Ability to stub query results
- [ ] Ability to stub dml operations
- [x] Ability to control which class level sharing rule is used for all crud ops
- [x] All CRUD ops use the strictest security settings by default.  Devs must decide to elevate when needed.  Apex by default runs in System Mode and tells devs to restrict when needed.
- [ ] Consolidate DML statements as much as possible to avoid running over limits
- [ ] Add support for a query builder to avoid long string concatenation
- [ ] Add invocables for queries via Flow
- [ ] Add invocables for dml via Flow
