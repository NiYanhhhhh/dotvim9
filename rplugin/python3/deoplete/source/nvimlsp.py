#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
#__filename__ : nvimlsp.py
#__author__   : niyan
#created date : 2021-04-27 22:29:01
"""

from deoplete.source.base import Base
import pynvim


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'nvimlsp'
        self.mark = '[lsp]'
        self.description = 'nvim build-in lsp source for deoplete'
        self.input_patterns = {
            'lua': '\w+|\w+[.:]\w*',
            #  'java': '[^. \t0-9]\.*\w*'
        }
        self.is_bytepos = True
        self.rank = 500

    def get_complete_position(self, context):
        return self.vim.call('nvimlsc#complete', 1, '')

    def gather_candidates(self, context):
        try:
            return self.vim.call('nvimlsc#complete',
                                 0, context['complete_str'])
        except pynvim.api.common.NvimError as er:
            print(er)
            raise er
