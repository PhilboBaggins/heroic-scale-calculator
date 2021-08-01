# Must be the "docs" directory to get project hosted on Github Pages
OUTPUT_DIR := ./docs

OUTPUT_FILES :=${OUTPUT_DIR}/index.html ${OUTPUT_DIR}/elm.js

.PHONY: all serve clean

all: ${OUTPUT_FILES}

${OUTPUT_DIR}/index.html: ./src/index.html
	@cp -v $< $@

${OUTPUT_DIR}/elm.js: ./src/Main.elm
	elm make --optimize $< --output=$@

serve: ${OUTPUT_FILES}
	(cd ${OUTPUT_DIR}; python -m http.server 8080)

clean:
	rm -f ${OUTPUT_FILES}
