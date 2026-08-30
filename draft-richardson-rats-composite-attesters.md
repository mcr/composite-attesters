---
title: Taxonomy of Composite Attesters
abbrev: composites
docname: draft-richardson-rats-composite-attesters-latest

# stand_alone: true

ipr: trust200902
area: Internet
wg: RATS Working Group
kw: Internet-Draft
cat: info

coding: utf-8
pi:    # can use array (if all yes) or hash here
  toc: yes
  sortrefs:   # defaults to yes
  symrefs: yes

author:

- ins: M. Richardson
  name: Michael Richardson
  org: Sandelman Software Works
  email: mcr+ietf@sandelman.ca
- ins: H. Birkholz
  name: Henk Birkholz
  org: Fraunhofer SIT
  email: henk.birkholz@ietf.contact
- ins: Y. Deshpande
  name: Yogesh Deshpande
  org: Arm
  email: yogesh.deshpande@arm.com
- ins: T. Fossati
  name: Thomas Fossati
  org: Linaro
  email: thomas.fossati@linaro.org

normative:
  BCP14: RFC8174
  RFC9334:
  I-D.ietf-rats-msg-wrap: cmw
informative:
  TCG-DICE:
    title: DICE Layering Architecture
    author:
      org: Trusted Computing Group
    seriesinfo: Version 1.0, Revision 0.19
    date: July 2020
    target: https://trustedcomputinggroup.org/wp-content/uploads/DICE-Layering-Architecture-r19_pub.pdf
  I-D.ffm-rats-cca-token: arm-cca

venue:
  group: rats
  mail: rats@ietf.org
  github: mcr/composite-attesters

--- abstract

This document was attempting to clarifys and extends the meaning of Composite Attester from RFC9334.
It has since been moved into the RATS wiki, and this I-D serves as a tombstone.

A system of annotated diagram components is defined as a small language to explain the different ways that components can interact to form composites.

These diagram components are then used to define a few popular classes of composites.

--- middle

# Introduction

This document was attempting to clarify and extend the meaning of Composite Attester from {{RFC9334, Section 3.3}}.

This work has been moved into the RATS wiki at: https://wiki.ietf.org/group/rats/atomic-composites

# IANA Considerations

There are none.

# Acknowledgements

Jun Zhang contributed the terms "Le Petit" and "Le Grand" to qualify Verifier, the original thought for Class 5 Composite Atteser and the description of the Nonce architecture.

# Changelog


--- back

