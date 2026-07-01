<?php

namespace App\Form;

use App\Dto\PriceDto;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\CallbackTransformer;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PriceType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        foreach (['priceA', 'priceB', 'priceC', 'priceD'] as $field) {
            $builder->add($field, NumberType::class);
            $builder->get($field)->addModelTransformer(new CallbackTransformer(
                fn (?\BcMath\Number $value): string => (string) ($value ?? ''),
                fn (?string $value): ?\BcMath\Number => null !== $value && '' !== $value ? new \BcMath\Number($value) : null,
            ));
        }
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PriceDto::class]);
    }
}
