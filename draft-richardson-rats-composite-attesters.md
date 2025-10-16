---
title: Taxonomy of Composite Attesters
abbrev: composites
docname: draft-richardson-rats-composite-attesters-latest

# stand_alone: true

ipr: trust200902
area: Internet
wg: anima Working Group
kw: Internet-Draft
cat: std

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

normative:
  BCP14: RFC8174
  RFC9334:

informative:

venue:
  group: rats
  mail: rats@ietf.org
  github: richardson/rats-composite-attesters

--- abstract

This document further refines different kinds of RFC 9334 Composite Attesters.

--- middle

# Introduction

This document clarifies and extends the meaning of Composite Attester from {{RFC9334, Section 3.3}}.

## Caveats of Current Definition

{{RFC9334, Section 3.3}} says:

```
   A composite device is an entity composed of multiple sub-entities
   such that its trustworthiness has to be determined by the appraisal
   of all these sub-entities.

   Each sub-entity has at least one Attesting Environment collecting the
   Claims from at least one Target Environment.  Then, this sub-entity
   generates Evidence about its trustworthiness; therefore, each sub-
   entity can be called an "Attester".  Among all the Attesters, there
   may be only some that have the ability to communicate with the
   Verifier while others do not.
```

In this description, it was left vague as to whether or not each Attesting Environment signs the Evidence that it generates, and whether or not the Evidence is evaluated by a Verifier operated by the Lead Attester, or if it's passed by the Lead Attester along with the Evidence from the Lead Target Environment.

## Terminology

Lead Attester:
: This term is from RFC9334, and includes the (Lead) Attesting Environment, and the (Lead) Target Environment.

Target Environment:
: This term is from RFC9334, this refers to the environment for which Evidence is gathered.

Attesting Environment:
: This term is from RFC9334, this refers to the thing which gathers the Evidence.

Component:
: This is the pieces which are attached to the Lead Attester.  There are one to many of these, typically each with their own application specific processor.

Component Evidence:
: This is the Evidence that is collected by the Component Attesting Environment about the Component Target Environment.

Component Attesting Environment:
: This term is new, and refers to an Attesting Environment residing inside a component of the whole.

Component Target Environment:
: This term is new, and refers to an environment for which Evidence is collected.

Verifier le petit:
: (Or, `Le Petit Verificateur`).  This is the Verifier that examines the Component Evidence.  This may treat the Lead Attester as a component.

Verifier la grand:
: (Or, `La Grande Verificateur`). This is the Verifier that examines the arrangement and relationships between Components.

## Class 0 Composite Attester

In this first, somewhat degenerate scenario, the Lead Attester has access to the entire memory/environment of all of the components.
Examples of situations like this include classic PCI-buses, ISA-buses, VME, S100/IEEE 696-1983.
In these situations, secondary components might not boot on their own.
(It might even be that the lead environment (the chassis) will place code into RAM for these systems, with no ROM at all)

In this case, it is possible for the Lead Attesting Environment to collect Claims about each of the components without the components having to have their own Attesting Environment.
There is no Verifier le petit, since there are no components that can create Evidence other than the Lead Attester.

At this Class, all of these components can be considered part of the same system.
In the classic PCI or ISA environment, the components are hard drive interfaces,
video interfaces, and network interfaces.
For many such systems considering the system to be a composite is unncessary additional complexity.

The benefit of applying the composite mechanism in this case is that it is no longer necessary to consider the exhaustive combinatorics of all possible components being attached to the lead attester: it is already the case the reference values for a target environment may change depending upon how much memory is installed.

In this Class 0 Composite Attester, the Evidence gathered about the components would be included in the Lead Attester's signed Evidence (such as an EAT), as sub-components
in UCCS form {{?RFC9781}}.
The signature from the Lead Attester applies to all the Evidence, but the Verifier can evaluate each component separately.

~~~~ aasvg
{::include diagrams/class0.txt}
~~~~
{: #class0diagram artwork-align="center" title="Class 0 Composite Attester"}


More modern buses like PCIe, InfiniBand, Thunderbolt, DisplayPort, USB, Firewire and others do not provided direct electrical access to target component system memory.
They are serialized versions of the old I/O buses, using a protocol akin to a network.
They require non-trivial deserialization at eacn end, requiring configuration via firmware that itself might not be trustworthy.
A system with such an interface would be a Class 1.

## Class 1 Composite Attester

In this Class, each component or slot has its own Attesting Environment and hence produces its own signed Evidence.

RFC 9334 gives the following example:


```
   For example, a carrier-grade router consists of a chassis and
   multiple slots.  The trustworthiness of the router depends on all its
   slots' trustworthiness.  Each slot has an Attesting Environment, such
   as a TEE, collecting the Claims of its boot process, after which it
   generates Evidence from the Claims.
```

The Lead Attester simply relays the Evidence along with its own:

```
   Among these slots, only a "main" slot can communicate with the
   Verifier while other slots cannot.  However, other slots can
   communicate with the main slot by the links between them inside the
   router.  The main slot collects the Evidence of other slots, produces
   the final Evidence of the whole router, and conveys the final
   Evidence to the Verifier.  Therefore, the router is a composite
   device, each slot is an Attester, and the main slot is the lead
   Attester.
```

Note that the Lead Attester does *not* evaluate the Evidence, and does not run its own
Verifier.

~~~~ aasvg
{::include diagrams/class1.txt}
~~~~
{: #class1diagram artwork-align="center" title="Class 1 Composite Attester"}

This diagram is intended to be identical to Figure 4 of {{RFC9334}}, but has been stretched out to allow the relationship to other classes to be clearer.



## Class 2 Composite/Hybrid Attester

In this scenario, the Components relay their Evidence to the Lead Attester.
The Lead Attester operates a Verifier itself.
It evaluates the Components' Evidence against Reference Values, Endorsements, etc. producing *Attestation Results*
These Attestation Results (or their selectively disclosed version: SD-CWT/SD-JWT)
are then included as part of the Lead Attester's Evidence to it's Verifier.

~~~~ aasvg
{::include diagrams/class2.txt}
~~~~
{: #class2diagram artwork-align="center" title="Class 2 Composite Attester"}

The Verifier's signing credentials may be part of the same Attesting Environment as the Evidence signing credential used by the Lead Attesting environment.
Or they could be in a different environment, such as in a different TEE.

## Class 3B Composite Background-Check Attester

In this scenario, the Components relay their Evidence to the Lead Attester.
The Lead Attester does *not* operates a Verifier itself.

Instead, the Lead Attester, conveys the Evidence to the Lead Verifier along with it's own Evidence.
The Component Evidence is not placed within the Lead Attester's Evidence (DEBATE).
The Lead Attester needs to communicate how each component is attached, and that would be within its Evidence.

~~~~ aasvg
{::include diagrams/class3B.txt}
~~~~
{: #class3Bdiagram artwork-align="center" title="Class 3B Composite Background-check Attester"}

The Lead Verifier, acting a Relying Party, connects to Component Verifiers capable of evaluating the Component Evidence, retrieving Attestation Results from those Verifiers as part of evaluating the Lead Attester.

This case is similar to Class 1, however the integration of the component attestation results in Class 1 is not included in the Evidence, while in this case, it is.

## Class 3P Composite Passport-Model Attester

In this scenario, the Components relay their Evidence to the Lead Attester.
The Lead Attester does *not* operates a Verifier itself.
Instead, the Lead Attester, acting as a Presenter (term To-Be-Defined), connects to an appropriate Verifier, in passport mode.
It retrieves an Attestation Result from the Verifier, which it then includes within the  Evidence that the Lead Attester produces.

The Lead Attester's Verifier considers the Components during it's assessment.
It needs to consider if the component has been assessed by a Verifier it trusts, if the component is appropriately connected to the Lead Attester, and if there are an appropriate number of such components.

~~~~ aasvg
{::include diagrams/class3P.txt}
~~~~
{: #class3Pdiagram artwork-align="center" title="Class 3P Composite Password Attester"}


For instance, when accessing a vehicle such as a car, where each tire is it's own component, then a car with three wheels is not trusthworthy.  Most cars should have four wheels.  A car with five wheels might be acceptable, if at least one wheel is installed into the "spare" holder. (And, it may be of concern if the spare is flat, but the car can still be operated)

A more typical digital use case would involve a main CPU with a number of attached specialized intelligent components that contain their own firmware, such as Graphical Processors (GPU), Network Processors (NPU).


## Class 4 Composite Attester

In certain systems, it is possible to have two independent Attesting Environments in an Attester to collect claims about a single Target Environment. In such cases, one of the Attesting Environment, acts as a Primary, while the other acts as a Secondary Attesting Environment.

The two Attesting Environments will have a fixed and collaborative structure where each can be responsible for a subset of Evidence. Because of the collaborative structure it may be arranged that either of the Attesting Environment can present Evidence collected by the other (but this is deployment specific).

~~~~ aasvg
{::include diagrams/class4.txt}
~~~~
{: #class4diagram artwork-align="center" title="Class 4 Composite (Dual) Attester"}

Example of one such system is a CPU system of a desktop from a Vendor X, which has its built in Attesting Environment, integrated into a product Y which requires a mandatory TPM support.
In such situations one can anchor the Roots of Trust of Vendor X's CPU Attestation using a secondary Attesting Environment with the TPM Attestation.
Alternatively, generate a TPM Quote and anchor it to Root of Trust of CPU Attestation based of Vendor X's Attesting Environment.

A Verifier/RP may decide to direct the Attestation Request to an AE of choice to reflect the relevant subset of Evidence required for trust asssessment.

## Class 5 Mixed Composite Attester

As soon as there is more than one Component, it is reasonable that the different Components interact with the Lead Attester in different ways.
A Mixed Composite Attester would have a components that come from different classes.
This is not a class itself, but a class of classes.

Degenerately, all previous classes can be considered mixes of one, but such a trivial category does not help discussionn.  Except that adding/moving/replacing Components in the field can change things, so some system architectures will need to always consider themselves to be Mixed Composite Attesters, even if when shipped, they might be degenerate instances.


# Attestation Results as Evidence

In cases 2, 3B and 3P Attestation Results are included as Evidence.
This results in a Verifier that must evaluate these results.
It must be able to validate the signatures on the Evidence.

This creates *stacked* Remote Attestation.
This is very much different and *distinct* from {{!RFC9334, Section 3.2}} Layered Attestation.

Layered Attestion produces a *single* set of Evidence, with claims about different layers.

# Privacy Considerations

YYY

# Security Considerations

ZZZ

# IANA Considerations

# Acknowledgements

Hello.

# Changelog


--- back

