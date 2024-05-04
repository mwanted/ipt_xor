/*
 * "XOR" target extension for xtables-addons
 * Copyright © Andrew Smith, 2014
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License; either
 * version 2 of the License, or any later version, as published by the
 * Free Software Foundation.
 */
#include <netinet/in.h>
#include <getopt.h>
#include <stdbool.h>
#include <stdio.h>
#include <xtables.h>
#include <linux/netfilter.h>
#include "xt_XOR.h"

#define _STRINGIFY(s) #s
#define STRINGIFY(s) _STRINGIFY(s)

enum {
    FLAGS_KEY = 1 << 0,
};

enum {
    O_XOR_KEY = 0,
};

static const struct option xor_opts[] = {
    {.name = "key", .has_arg = true, .val = O_XOR_KEY},
    {},
};

static void xor_help(void)
{
    printf(
            "XOR target options:\n"
            "    --key <byte string>\n"
          );
}

static int xor_parse(int c, char **argv, int invert, unsigned int *flags,
        const void *entry, struct xt_entry_target **target)
{
    struct xt_xor_info *info = (void *)(*target)->data;
    const char *s = optarg;

    unsigned char *dst = info->key;
    unsigned char *end = info->key + sizeof(info->key);
    unsigned int b;

    while (dst < end && sscanf(s, "%2x", &b) == 1) {
        *dst++ = b;
        info->key_len++;
        s += 2;
    }

    if (info->key_len == 0 || *s != '\0') {
        xtables_error(PARAMETER_PROBLEM, "XOR: "
                "keys length, > 0 and <= " STRINGIFY(XT_XOR_MAX_KEY_SIZE));
        return false;
    }

    *flags |= FLAGS_KEY;
    return true;
}

static void xor_check(unsigned int flags)
{
    if (flags & FLAGS_KEY)
        return;

    xtables_error(PARAMETER_PROBLEM, "XOR: --key parameter is required.");
}

static void xor_print(const void *entry, const struct xt_entry_target *target, int numeric)
{
    const struct xt_xor_info *info = (const void *)target->data;

    const unsigned char* i = info->key;
    const unsigned char* end = info->key + info->key_len;

    printf(" --key ");
    for (; i < end; ++i) {
        printf("%02x", *i);
    }
}

static void xor_save(const void *entry, const struct xt_entry_target *target)
{
    const struct xt_xor_info *info = (const void *)target->data;

    const unsigned char* i = info->key;
    const unsigned char* end = info->key + info->key_len;

    printf(" --key ");
    for (; i < end; ++i) {
        printf("%02x", *i);
    }
}

static struct xtables_target xor_reg[] = {
    {
        .version       = XTABLES_VERSION,
        .name          = "XOR",
        .revision      = 0,
        .family        = NFPROTO_IPV4,
        .size          = XT_ALIGN(sizeof(struct xt_xor_info)),
        .userspacesize = XT_ALIGN(sizeof(struct xt_xor_info)),
        .help          = xor_help,
        .parse         = xor_parse,
        .final_check   = xor_check,
        .print         = xor_print,
        .save          = xor_save,
        .extra_opts    = xor_opts,
    },
    {
        .version       = XTABLES_VERSION,
        .name          = "XOR",
        .revision      = 0,
        .family        = NFPROTO_IPV6,
        .size          = XT_ALIGN(sizeof(struct xt_xor_info)),
        .userspacesize = XT_ALIGN(sizeof(struct xt_xor_info)),
        .help          = xor_help,
        .parse         = xor_parse,
        .final_check   = xor_check,
        .print         = xor_print,
        .save          = xor_save,
        .extra_opts    = xor_opts,
    },
};

static __attribute__((constructor)) void init_xt_xor(void)
{
    xtables_register_targets(xor_reg, sizeof(xor_reg) / sizeof(*xor_reg));
}

#undef STRINGIFY
#undef _STRINGIFY
