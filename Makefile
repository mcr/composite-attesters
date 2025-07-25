DRAFT:=composite-attesters
VERSION:=$(shell ./getver ${DRAFT}.mkd )
EXAMPLES=
XML2RFC=/corp/ietf/venv/bin/xml2rfc

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

%.xml: %.mkd
	kramdown-rfc2629 -3 ${DRAFT}.mkd >${DRAFT}.xml
	${XML2RFC} --v2v3 ${DRAFT}.xml
	mv ${DRAFT}.v2v3.xml ${DRAFT}.xml

%.txt: %.xml
	${XML2RFC} --text -o $@ $?

%.html: %.xml
	${XML2RFC} --html -o $@ $?

submit: ${DRAFT}.xml
	curl -s -F "user=mcr+ietf@sandelman.ca" ${REPLACES} -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submission | jq

version:
	echo Version: ${VERSION}

clean:
	-rm -f ${DRAFT}.xml

.PRECIOUS: ${DRAFT}.xml
